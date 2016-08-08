#!/usr/bin/env python
# -*- coding: utf-8 -*-
# @Date    : 2016-05-27
# @Author  : guangjian (guangjian@gmail.com)
# @Link    : http://www.liuruhan.com
# @Version : $Id$

import web
import xml.etree.ElementTree as ET

tree = ET.parse('users.xml')
#tree = ET.parse('resourceChangeNotifications.xml')
root = tree.getroot()

urls=(
    '/users','list_users',
    '/users/(.*)','get_user',
    '/v1/resourceChangeNotifications','resource_change_notify',
    '/v1/pm/.*/notification','pm_job_notify'

)
app = web.application(urls, globals())

class list_users:
    def GET(self):
        output = 'users:[';
        for child in root:
            print 'child',child.tag,child.attrib
            output +=str(child.attrib)+','
        output += ']';
        return output
class get_user:
    def GET(self,user):
        for child in root:
            if child.attrib['id']==user:
            		return str(child.attrib)
class resource_change_notify:
    def GET(self):
        output = 'resource:[';
        for child in root:
            print 'child',child.tag,child.attrib
            output +=str(child.attrib)+','
        output += ']';
        return output
    def POST(self):
#        ua = web.ctx.env['HTTP_USER_AGENT']
	i = web.data()


        print "notify json is :";
        print i;
 
	output ='';
        return output


class pm_job_notify:
    def GET(self):
        output = 'resource:[';
        for child in root:
            print 'child',child.tag,child.attrib
            output +=str(child.attrib)+','
        output += ']';
        return output
    def POST(self):
#        ua = web.ctx.env['HTTP_USER_AGENT']
        i = web.data()


        print "pm job notify json is :";
        print i;

        output ='';
        return output
            	    
if __name__ == '__main__':
        app.run()

