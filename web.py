# -*- coding: UTF-8 -*-
#
# Juan Hernandez, 2013
#

import os

from lib.states import get_states

from odoolib.api import OdooLib

import cherrypy as cpy

from apps.mako_template import s_template

from odoolib.api import OdooLib

SESSION_KEY = '_cp_username'
current_dir = os.path.dirname(os.path.abspath(__file__))

ODOO_URL = os.environ.get('ODOO_URL')
ODOO_DB = os.environ.get('ODOO_DB')
ODOO_USER = os.environ.get('ODOO_USER')
ODOO_PASSWORD = os.environ.get('ODOO_PASSWORD')


class Root(object):
    def __init__(self):
        super(Root, self).__init__()

    @cpy.expose
    def po(self, *args, **kwargs):
        d = {'success': False, 'comment': False, 'warning': False}

        if args:
            odoo_id = args[0]
            ol = OdooLib(ODOO_URL, ODOO_DB, ODOO_USER, ODOO_PASSWORD)
            po = ol.purchase_order.get(cherrypy_id=odoo_id)

            # TODO: Check retries for security?
            if not po:
                # Return the least amount possible of CPU cycles
                return ''

            if kwargs:
                tracking = kwargs.get('tracking_number')
                comments = kwargs.get('comments')
                carrier = kwargs.get('carrier')

                if not tracking and not comments:
                    print '\n\nNO!'
                    d['warning'] = True
                else:
                # If Tracking#, update PO
                    p_rec = {}
                    if kwargs.get('tracking_number'):
                        p_rec['cherrypy_status'] = True
                        p_rec['tracking_number'] = tracking
                    if kwargs.get('comments'):
                        p_rec['vendor_comments'] = kwargs.get('comments')
                    if kwargs.get('carrier'):
                        p_rec['mail_carrier'] = kwargs.get('carrier')

                    # Update PO
                    ol.purchase_order.update(po.get('id'), p_rec)

                    # Set messages
                    if tracking:
                        d['success'] = True
                    elif comments:
                        d['comment'] = True

                    # TODO: Notify people that a comment has been submitted
                    # notify comment

                    if tracking:
                        cpy.session['success'] = True
                        raise cpy.HTTPRedirect('')

            d['purchase_order'] = po

            try:
                return s_template('po.mako', **d)
            except Exception, e:
                return str(e)
        else:
            return ''

    @cpy.expose
    def get_po(self, hash_id):
        """
        Get PDF file
        """
        ol = OdooLib(ODOO_URL, ODOO_DB, ODOO_USER, ODOO_PASSWORD)
        # Get Order ID based on hash
        #o_id = ol.purchase_order.get(cherrypy_id=hash_id, model_fields=['id'])
        file = ol.purchase_order.get_report('purchase.order', 200)

        cpy.response.headers['Content-Type'] = 'application/pdf'
        cpy.response.headers['Content-Disposition'] = ('attachment; '
                                                       'filename='
                                                       '"order.pdf"')
        return file

    @cpy.expose
    def register(self, **kwargs):
        d = {'states': get_states()}
        print get_states()
        if kwargs:
            for k, v in kwargs.iteritems():
                cpy.session[k] = v
            raise cpy.HTTPRedirect('/stripe/')
        try:
            return s_template('register.mako', **d)
        except Exception, e:
            return str(e)

    @cpy.expose
    def stripe(self, *args, **kwargs):
        if cpy.session.get('name'):
            d = {
                'card_state': False,
                'payment_string': 'mi.Hair Subscription'
            }

            # TODO: get from odoo
            subscription_price = 25

            tablet_qty = int(cpy.session.get('tablet_qty'))
            d['email'] = cpy.session.get('email')
            d['tablet_qty'] = tablet_qty
            d['cents_amnt'] = tablet_qty * 100 * subscription_price
            d['total_amnt'] = tablet_qty * subscription_price

            if kwargs:
                import stripe
                # TODO: get from Odoo
                stripe.api_key = "sk_test_t7onGzbXUvAJ6j95ZLgi2sUg"
                token = kwargs['stripeToken']

                try:
                    charge = stripe.Charge.create(
                        # amount in cents, again
                        amount=d['cents_amnt'],
                        currency="usd",
                        card=token,
                        description="payinguser@example.com"
                    )
                    d['charge'] = charge
                    d['card_state'] = True

                    ol = OdooLib(ODOO_URL, ODOO_DB, ODOO_USER, ODOO_PASSWORD)
                    # Add info to ODOO
                    ## Add partner
                    # TODO: Check email before submit
                    partner_id = ol.res_partner.add(
                        company_id=1,
                        active=True,
                        customer=True,
                        supplier=False,
                        is_salon=True,
                        is_company=True,
                        name=cpy.session.get('name'),
                        email=cpy.session.get('email'),
                        street=cpy.session.get('address'),
                        city=cpy.session.get('city'),
                        state_id=cpy.session.get('state'),
                        zip=cpy.session.get('zipcode'),
                        phone=cpy.session.get('phone_1'),
                        mobile=cpy.session.get('phone_2'),
                        # USA
                        country_id=235,
                    )
                    # Set opportunity to won and send info to spree
                    ## Add crm lead with associated partner
                    lead_id = ol.crm_lead.add(
                        name=cpy.session.get('name'),
                        partner_id=partner_id,
                        tablet_qty=cpy.session.get('tablet_qty'),
                        type='opportunity',
                        stage_id=6,
                    )
                    ## Mark oppportinity as won
                    ol.crm_lead.execute('case_mark_won', [lead_id])

                    # Delete user info session (do one by one)

                except stripe.CardError, e:
                    # The card has been declined
                    print '\n\nDECLINED\n\n {}'.format(e)

            try:
                return s_template('stripe.mako', **d)
            except Exception, e:
                return str(e)
        else:
            raise cpy.HTTPRedirect('/register/')

    @cpy.expose
    def stripejs(self, *args, **kwargs):
        print '\nArgs: {}'.format(args)
        print '\nKwrgs: {}'.format(kwargs)

        return s_template('stripe_js.mako')


##
# Server
if os.environ.get('DEV_STATE') == 'PRODUCTION':
    print '\n\n Im {}'.format(os.environ.get('DEV_STATE'))
    # Set PID
    from cherrypy.process.plugins import PIDFile
    p = PIDFile(cpy.engine, "/opt/python/pids/cherrypy-basic.pid")
    p.subscribe()

    # INIT
    from cherrypy.process.plugins import Daemonizer
    Daemonizer(cpy.engine).subscribe()

    cpy.config.update(current_dir + '/conf/cherry_conf')
    cpy.tree.mount(Root(), "/", config=current_dir + '/conf/cherry_conf')

    cpy.engine.start()
    cpy.engine.block()

else:
    print '\n\n Im {}'.format(os.environ.get('DEV_STATE'))
    cpy.config.update('conf/cherry_conf')
    cpy.tree.mount(Root(), '/')
