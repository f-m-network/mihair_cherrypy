# -*- coding: UTF-8 -*-
#
# Juan Hernandez, 2013
#

import os
import cherrypy as cpy
from mako.lookup import TemplateLookup

active_theme = "themes/default/"


def s_template(template, **kwargs):
    """Basic Template """

    root_dir = cpy.request.app.config.get('global').get('root_dir')

    lookup = TemplateLookup(directories=[root_dir + '/mako/'],
                            input_encoding='utf-8',
                            output_encoding='utf-8',
                            default_filters=['decode.utf8'],
                            encoding_errors='replace'
                            )

    d = {
        'headers': cpy.response.header_list,
        'request': cpy.request.headers,
        'url': cpy.url(),
        'cpy': cpy,
        'config': cpy.request.config,
        'static_version': 'v1.1',
        'static_dir': '/static/' + active_theme
    }

    d.update(kwargs)
    mt = lookup.get_template(template)
    #return mt.render_unicode(**d).encode('utf-8')
    return mt.render(**d)
