## -*- coding: utf-8 -*-
<%inherit file="base.mako"/>

<%block name="content">
    <div class="container-fluid" style="padding: 10%; padding-top: 2%" align="center"> <form action="" method="POST" >
        <table width="60%">
            <tr >
                <td colspan="2" align="center">
                    <h2>New Subscription</h2>
                </td>
            </tr>
            <tr>
                <th class="fa-border">
                    <label for="email">
                        <strong>email</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="email" required="required" name="email" id="email">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="name">
                        <strong>Salon name</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" required="required" name="name" id="name">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="address">
                        <strong>Address</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" required="required" name="address" id="address">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="city">
                        <strong>City</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" required="required" name="city" id="city">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="state">
                        <strong>State</strong>
                    </label></th>
                <td class="fa-border">
                    <select name="state" id="state" required="required">
                        <%
                         selected = ''
                        %>
                        % for state in states:
                            <%
                                if state.get('id') == 10:
                                    selected = 'selected'
                                else:
                                    selected = ''
                            %>
                            <option value="${state.get('id')}" ${selected}>${state.get('name')}</option>
                        % endfor
                    </select>
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="zipcode">
                        <strong>Zip Code</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" required="required" name="zipcode" id="zipcode">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="website">
                        <strong>Website URL</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" name="website" id="website">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="phone_1">
                        <strong>Phone</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" required="required" name="phone_1" id="phone_1">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="phone_2">
                        <strong>Mobile</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="text" name="phone_2" id="phone_2">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="tablet_qty">
                        <strong>Tablet Quantity</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="number" name="tablet_qty" id="tablet_qty" required="required">
                </td>
            </tr>

            <tr>
                <th class="fa-border">
                    <label for="wifi">
                        <strong>WiFi</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="checkbox" name="wifi" id="wifi">
                </td>
            </tr>


            <tr>
                <th class="fa-border">
                    <label for="online_scheduling">
                        <strong>Online Scheduling</strong>
                    </label></th>
                <td class="fa-border">
                    <input type="checkbox" name="online_scheduling" id="online_scheduling">
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div class="form-actions" align="center">
                            <input class="button btn btn-primary"
                                   name="commit" type="submit"
                                   value="Create Subscription"/>
                    </div>
                </td>
            </tr>

        </table>
    </form>
    </div>
</%block>
