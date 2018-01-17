#!/usr/bin/env python
#
# Copyright 2012 Jared Boone
#
# This file is part of HackRF.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, Inc., 51 Franklin Street,
# Boston, MA 02110-1301, USA.
#

#import os
#os.environ['PYUSB_DEBUG'] = 'debug'
#os.environ['PYUSB_LOG_FILENAME'] = 'D:\work\LCSDR\src\python\log.txt'

import usb1
from array import array
import time
#import struct
#import sys
import multiprocessing

def read_cb(t):
    #print('hit')
    #return True
    t.submit()

def read_data_thread(cnt,size):
    context = usb1.USBContext()
    #print('captured libusb devices:\n')
    #print(context.getDeviceList())
    try :
        handle = context.openByVendorIDAndProductID(
                0x04b4,0x00f1
                )
        print('success')
    except:
        print('device not found')
        exit(1)
    handle.claimInterface(0)
    th = usb1.USBTransferHelper()
    th.setEventCallback(usb1.TRANSFER_COMPLETED,read_cb)

    tranlist = [0,1,2,3,4,5]
    for x in [0,1]: 
        tranlist[x]= handle.getTransfer()
        tranlist[x].setBulk(0x86,2048,callback=read_cb)
        tranlist[x].submit()
    #trans.setBulk(0x86,2048,callback=read_cb)
    #print(trans.getStatus())
    #trans.submit()
    #print(trans.isSubmitted())
    print('submitted')

    #device = usb.core.find(idVendor=0x04b4)
    #print(device)
    #print(device.backend)
    ##print(device.manufacturer)
    ##print(device.product)
    #print('list of the device config:\n',device.configurations())
    #print('will set this default config')
    #device.set_configuration()
    #print(device[0][0,0][0])
    #print(device[0][0,0][1])
    #data = array('B')
    #data.fromlist(list(range(0,256)))
    #data.fromlist(list(range(0,256)))
    #data.fromlist([0]*512)
    #data[510]=2
    #data[508]=2
    #data[506]=4
    #data.fromlist(list(range(255,-1,-1)))


    #wlen = device.write(0x2,array('h',[1,2]))
    #wlen = device.write(0x2,data)
    #print(wlen,'Bs send.')
    #print(data)
    time.sleep(0.1)
    rdata = array('H')
    rdata.fromlist([0]*size)
    #rdata = device.read(0x86,4)
    #rdata = device.read(0x86,512)

    while 1 :
        context.handleEvents()
        #device.read(0x86,rdata)
        #rdata = handle.bulkRead(0x86,size*2)
        #cnt.value = cnt.value + 1
        #print(len(rdata),'received')
        #print('%x' % (rdata[0] & 0x03))
        #print('%x' % rdata[0])
        #print(rdata[0])
        #print(rdata)

if __name__ == '__main__':
    #device.read(0x86,rdata)
    #print(len(rdata),'received')
    #print(rdata)
    print(usb1.getVersion())
    size = 2048
    cnt = multiprocessing.Value('i',0)
    t_read_data=multiprocessing.Process(target=read_data_thread,args=(cnt,size,))
    t_read_data.daemon=True
    t_read_data.start()

    count = 0
    while 1:
        time.sleep(1)
        #print((cnt.value - count)*size/1000)
        #count = cnt.value

