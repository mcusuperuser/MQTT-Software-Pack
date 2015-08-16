# Software Pack for the Eclipse Paho MQTT C/C++ client for Embedded platforms

This repository contains the source code from the [Eclipse Paho](http://eclipse.org/paho) MQTT C/C++ client library for Embedded platforms.

It is dual licensed under the EPL and EDL (see license.rtf for more details).  You can choose which of these licenses you want to use the code under.  The EDL allows you to embed the code into your application, and distribute your application in binary or source form without contributing any of your code, or any changes you make back to Paho.  See the EDL for the exact conditions.

The MQTTPacket directory contains the lowest level C library with the smallest requirements.  This supplies simple serialization 
and deserialization routines.  It is mainly up to you to write and read to and from the network.

The MQTTClient directory contains the next level C++ library.  This still avoids most networking code so that you can plugin the
network of your choice.

## Build requirements / compilation

To successfully build the Pack, you need a Windows PC with Keil MDK Version 5, 7-ZIP, and the GNU wget for Windows installed. The
gen_pack.bat batch script will download the source from Paho and create the Pack automatically.

## Usage and API

See https://www.eclipse.org/paho/clients/c/embedded/

## Reporting bugs

Please report bugs in the GitHub project or to packs@mcusuperuser.com
