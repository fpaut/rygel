/*
 * Copyright (C) 2008 Zeeshan Ali <zeenix@gmail.com>.
 * Copyright (C) 2008-2012 Nokia Corporation.
 *
 * Author: Zeeshan Ali <zeenix@gmail.com>
 *         Jens Georg <jensg@openismus.com>
 *
 * This file is part of Rygel.
 *
 * Rygel is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Rygel is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

using GUPnP;
using Gee;
using Tracker;

/**
 * Container listing possible values of a particuler Tracker metadata key.
 */
public abstract class Rygel.Tracker.MetadataValues : Rygel.SimpleContainer {
    /* class-wide constants */
    private const string TRACKER_SERVICE = "org.freedesktop.Tracker1";
    private const string RESOURCES_PATH = "/org/freedesktop/Tracker1/Resources";

    private ItemFactory item_factory;
    private bool update_in_progress = false;

    private string property;

    private string child_class;

    private Sparql.Connection resources;

    public MetadataValues (string         id,
                           MediaContainer parent,
                           string         title,
                           ItemFactory    item_factory,
                           string         property,
                           string?        child_class = null) {
        base (id, parent, title);

        this.item_factory = item_factory;
        this.property = property;
        this.child_class = child_class;

        try {
            this.resources = Sparql.Connection.get ();
        } catch (Error error) {
            critical (_("Failed to create Tracker connection: %s"), error.message);

            return;
        }

        this.fetch_metadata_values.begin ();
    }

    internal async void fetch_metadata_values () {
        if (this.update_in_progress) {
            return;
        }

        this.update_in_progress = true;
        // First thing, clear the existing hierarchy, if any
        this.clear ();

        int i;
        var triplets = new QueryTriplets ();

        triplets.add (new QueryTriplet (SelectionQuery.ITEM_VARIABLE,
                                        "a",
                                        this.item_factory.category));

        var key_chain_map = KeyChainMap.get_key_chain_map ();
        var selected = new ArrayList<string> ();
        selected.add ("DISTINCT " +
                      key_chain_map.map_property (this.property) +
                      " AS x");

        var query = new SelectionQuery (selected,
                                        triplets,
                                        null,
                                        "?x");

        try {
            yield query.execute (this.resources);

            while (query.result.next ()) {
                string value = query.result.get_string (0);

                if (value == "") {
                    continue;
                }

                var title = this.create_title_for_value (value);
                if (title == null) {
                    continue;
                }

                var id = this.create_id_for_title (title);
                if (id == null || !this.is_child_id_unique (id)) {
                    continue;
                }

                // The child container can use the same triplets we used in our
                // query.
                var child_triplets = new QueryTriplets.clone (triplets);

                // However we constrain the object of our last triplet.
                var filters = new ArrayList<string> ();
                var property = key_chain_map.map_property (this.property);
                var filter = this.create_filter (property, value);
                filters.add (filter);

                var container = new SearchContainer (id,
                                                     this,
                                                     title,
                                                     this.item_factory,
                                                     child_triplets,
                                                     filters);
                if (this.child_class != null) {
                    container.upnp_class = child_class;
                }

                this.add_child_container (container);
            }
        } catch (Error error) {
            critical (_("Error getting all values for '%s': %s"),
                      this.id,
                      error.message);
            this.update_in_progress = false;

            return;
        }


        this.updated ();
        this.update_in_progress = false;
    }

    public override async MediaObject? find_object (string       id,
                                                    Cancellable? cancellable)
                                                    throws GLib.Error {
        if (this.is_our_child (id)) {
            return yield base.find_object (id, cancellable);
        } else {
            return null;
        }
    }

    protected virtual string? create_id_for_title (string title) {
        return this.id + ":" + Uri.escape_string (title, "", true);
    }

    protected virtual string? create_title_for_value (string value) {
        return value;
    }

    protected virtual string create_filter (string variable, string value) {
        return variable + " = \"" + Query.escape_string (value) + "\"";
    }

    private bool is_our_child (string id) {
        return id.has_prefix (this.id + ":");
    }
}

