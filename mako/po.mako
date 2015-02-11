## -*- coding: utf-8 -*-
<%inherit file="base.mako"/>

<%!
    import cherrypy as cpy

    from odoolib.api import OdooLib
    import os

    ODOO_URL = os.environ.get('ODOO_URL')
    ODOO_DB = os.environ.get('ODOO_DB')
    ODOO_USER = os.environ.get('ODOO_USER')
    ODOO_PASSWORD = os.environ.get('ODOO_PASSWORD')

    ol = OdooLib(ODOO_URL, ODOO_DB, ODOO_USER, ODOO_PASSWORD)
%>

<%block name="content">

    <div class="container">
        <div class="text-center">
            <h2>
                ${purchase_order.get('partner_id')[1]}
            </h2>
        </div>

        <div class="row">
            % if cpy.session.pop('success'):
                <div class="alert-success"
                     style="box-shadow: 2px 2px 5px #888888; border-radius: 25px; border: 2px solid;"
                     align="center">
                    Your tracking number has been registered. We will contact the client shortly
                </div>
            % endif
            % if comment:
                <div class="alert-info"
                     style="box-shadow: 2px 2px 5px #888888; border-radius: 25px; border: 2px solid;"
                     align="center">
                    Your comment has ben registered. We will contact you shortly
                </div>
            % endif
            % if warning:
                <div class="alert-warning"
                     style="box-shadow: 2px 2px 5px #888888; border-radius: 25px; border: 2px solid;"
                     align="center">
                    You must enter a tracking number or a comment
                </div>
            % endif


            <div class="col-centered">
                    <h3><strong>Purchase Order:</strong>
                        <a>${purchase_order.get('name')}
                            <a href="/get_po/${purchase_order.get('spree_id')}">
                                <i class="fa fa-download"></i>
                            </a>
                        </a>
                    </h3>
                    <table width="100%">
                        <tr>
                            <th>Order Line</th>
                            <th width="80%">Product</th>
                            <th>QTY</th>
                            <th>Price</th>
                            <th>Subtotal</th>
                        </tr>
                        % for line in purchase_order.get('order_line'):
                            <%
                                order_line = ol.purchase_order_line.get(id=line)
                            %>

                            <tr>
                                <td class="fa-border">${line}</td>
                                <td class="fa-border">
                                            <a>
                                                ${order_line.get('product_id')[1]}
                                            </a>
                                </td>
                                <td class="fa-border" align="right">
                                    ${order_line.get('product_qty')}
                                </td>
                                <td class="fa-border" align="right">
                                    ${order_line.get('price_unit')}
                                </td>
                                <td class="fa-border" align="right">
                                    ${order_line.get('price_subtotal')}
                                </td>

                            </tr>
                        % endfor
                            <tr>
                                <td></td>
                                <td></td>
                                <td class="fa-border" colspan="2" align="right">
                                    <strong>
                                        Total
                                    </strong>
                                </td>
                                <td class="fa-border" align="right">
                                        ${purchase_order.get('amount_total')}
                                </td>
                            </tr>

                    </table>

                    % if not purchase_order.get('cherrypy_status'):
                        <form accept-charset="UTF-8" action=""
                              class="simple_form new_user" method="post">
                            <h3>Submit Order</h3>
                            <hr>
                            <table class="">
                                <tr>
                                    <th width="120">Carrier</th>
                                    <th width="200px">Tracking Number</th>
                                    <th>Comments</th>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="form-inputs">
                                            <div class="form-group">
                                                <select name="carrier"
                                                        id="carrier">
                                                    <option value="">---</option>
                                                    <option value="USPS">USPS</option>
                                                    <option value="UPS">UPS</option>
                                                    <option value="FEDEX">FEDEX</option>
                                                    <option value="DHL">DHL</option>
                                                </select>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-inputs">
                                            <div class="form-group required">
                                                <input aria-required="true" autofocus="autofocus"
                                                       class="string required form-control form-control"
                                                       id="tracking_number"
                                                       name="tracking_number"
                                                       maxlength="255"
                                                       size="255" type="text" value=""/>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-inputs">
                                            <div class="form-group required">
                                                <input aria-required="true" autofocus="autofocus"
                                                       class="string form-control form-control"
                                                       id="comments"
                                                       name="comments"
                                                       maxlength="255"
                                                       size="255" type="text" value=""/>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                        </table>

                        <div class="form-actions" align="right">
                            <input class="button btn btn-primary"
                                   name="commit" type="submit"
                                   value="Submit Orders"/>
                        </div>

                        </form>

                    % else:

                        <hr>
                        <table width="100%">
                            <tr>
                                <td width="80%" align="right">
                                    <strong>Carrier: </strong> </td>
                                <td align="right" style="padding-left: 10px">
                                    ${purchase_order.get('mail_carrier')}
                                </td>
                                <td width="80%" align="right">
                                    <strong>Tracking Number: </strong>
                                </td>
                                <td align="right" style="padding-left: 10px">
                                    ${purchase_order.get('tracking_number')}
                                </td>
                            </tr>
                        </table>
                    % endif

            <table width="100%">
                <tr>
                    <td>
                        <h3>Shipping Address</h3>
                        <hr>
                        <table class="">
                            <tr>
                                <th>Full Name: </th>
                                <td>${purchase_order.get('spree_billing_full_name')}</td>
                            </tr>
                            <tr>
                                <th>Address 1: </th>
                                <td>${purchase_order.get('spree_billing_address1')}</td>
                            </tr>
                            <tr>
                                <th>Address 2: </th>
                                <td>${purchase_order.get('spree_billing_address2')}</td>
                            </tr>
                            <tr>
                                <th>City: </th>
                                <td>${purchase_order.get('spree_billing_city')}</td>
                            </tr>
                            <tr>
                                <th>State: </th>
                                <td>${purchase_order.get('spree_billing_state')}</td>
                            </tr>
                            <tr>
                                <th>Phone: </th>
                                <td>${purchase_order.get('spree_billing_phone')}</td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <h3>Billing Address</h3>
                        <hr>
                        <table class="">
                            <tr>
                                <th>Full Name: </th>
                                <td>${purchase_order.get('spree_shipping_full_name')}</td>
                            </tr>
                            <tr>
                                <th>Address 1: </th>
                                <td>${purchase_order.get('spree_shipping_address1')}</td>
                            </tr>
                            <tr>
                                <th>Address 2: </th>
                                <td>${purchase_order.get('spree_shipping_address2')}</td>
                            </tr>
                            <tr>
                                <th>City: </th>
                                <td>${purchase_order.get('spree_shipping_city')}</td>
                            </tr>
                            <tr>
                                <th>State: </th>
                                <td>${purchase_order.get('spree_shipping_state')}</td>
                            </tr>
                            <tr>
                                <th>Phone: </th>
                                <td>${purchase_order.get('spree_shipping_phone')}</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </div>

</%block>
