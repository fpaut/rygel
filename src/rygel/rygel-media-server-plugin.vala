/*
 * Copyright (C) 2008,2010 Nokia Corporation.
 *
 * Author: Zeeshan Ali (Khattak) <zeeshanak@gnome.org>
 *                               <zeeshan.ali@nokia.com>
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

public abstract class Rygel.MediaServerPlugin : Rygel.Plugin {
    private static const string MEDIA_SERVER_DESC_PATH =
                                BuildConfig.DATA_DIR + "/xml/MediaServer2.xml";

    public MediaServerPlugin (string  name,
                              string? title,
                              string? description = null) {
        base (MEDIA_SERVER_DESC_PATH, name, title, description);

        // MediaServer implementations must implement ContentDirectory service
        var info = new ResourceInfo (ContentDirectory.UPNP_ID,
                                     ContentDirectory.UPNP_TYPE,
                                     ContentDirectory.DESCRIPTION_PATH,
                                     typeof (ContentDirectory));
        this.add_resource (info);

        // Register Rygel.ConnectionManager
        info = new ResourceInfo (ConnectionManager.UPNP_ID,
                                 ConnectionManager.UPNP_TYPE,
                                 ConnectionManager.DESCRIPTION_PATH,
                                 typeof (SourceConnectionManager));

        this.add_resource (info);
        info = new ResourceInfo (MediaReceiverRegistrar.UPNP_ID,
                                 MediaReceiverRegistrar.UPNP_TYPE,
                                 MediaReceiverRegistrar.DESCRIPTION_PATH,
                                 typeof (MediaReceiverRegistrar));
        this.add_resource (info);

        var root_container = this.get_root_container ();
        if (root_container.child_count == 0) {
            debug ("Deactivating plugin '%s' until it provides content.",
                   this.name);

            this.active = false;

            root_container.container_updated.connect
                                        (this.on_container_updated);
        }
    }

    public abstract MediaContainer get_root_container ();

    private void on_container_updated (MediaContainer root_container,
                                       MediaContainer updated) {
        if (updated != root_container || updated.child_count == 0) {
            return;
        }

        root_container.container_updated.disconnect
                                        (this.on_container_updated);

        debug ("Activating plugin '%s' since it now provides content.",
               this.name);

        this.active = true;
    }
}

