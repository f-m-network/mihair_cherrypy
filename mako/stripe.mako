## -*- coding: utf-8 -*-
<%inherit file="base.mako"/>

<%block name="content">
    % if not card_state:
        <div class="container">
            <form action="" method="POST" style="padding: 150px">
              <script
                src="https://checkout.stripe.com/checkout.js" class="stripe-button"
                data-email="${email}"
                data-key="pk_test_dsAJmxh4TAyrbYsxXXVhhYYx"
                data-amount="${cents_amnt}"
                data-panel-label="Monthly Payment:"
                data-allow-remember-me=false
                data-name="${payment_string}"
                data-description="${tablet_qty} subscriptions ($${total_amnt})"
                data-image="/static/whu.png">
              </script>
            </form>
        </div>
    % else:
        <h2>${charge}</h2>
    % endif

</%block>
