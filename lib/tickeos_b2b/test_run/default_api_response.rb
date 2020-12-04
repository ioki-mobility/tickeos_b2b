# frozen_string_literal: true

require 'base64'

module TickeosB2b
  module TestRun
    class DefaultApiResponse
      def self.options
        {
          product_list: [
            {
              name:         'Single ticket - Adult',
              reference_id: 'ST_Adult'
            },
            {
              name:         'Single ticket - Child',
              reference_id: 'ST_Child'
            },
            {
              name:         'Group ticket',
              reference_id: 'GT'
            }
          ],
          product_data: {
            ST_Adult: {
              id:                         '01',
              vu_name:                    'vu_name',
              vu_role:                    'role',
              sort_order:                 '1',
              tariff_zone_count:          '0',
              tariff_zone_count_required: '0',
              sale_date_from:             '',
              sale_date_to:               '',
              distribution_method:        'mobile',
              visible:                    '1'
            },
            ST_Child: {
              id:                         '02',
              vu_name:                    'vu_name',
              vu_role:                    'role',
              sort_order:                 '2',
              tariff_zone_count:          '0',
              tariff_zone_count_required: '0',
              sale_date_from:             '',
              sale_date_to:               '',
              distribution_method:        'mobile',
              visible:                    '1'
            },
            GT:       {
              id:                         '03',
              vu_name:                    'vu_name',
              vu_role:                    'role',
              sort_order:                 '3',
              tariff_zone_count:          '0',
              tariff_zone_count_required: '0',
              sale_date_from:             '',
              sale_date_to:               '',
              distribution_method:        'mobile',
              visible:                    '1'
            }
          },
          purchase:     {
            ST_Adult: {
              server_ordering_serial:      '2012112900001',
              server_order_product_serial: '1211599',
              price_net:                   '3.25',
              price_gross:                 '3.5',
              price_vat:                   '0.25',
              price_vat_rate:              '7'
            },
            ST_Child: {
              server_ordering_serial:      '2012112900002',
              server_order_product_serial: '1211600',
              price_net:                   '3.25',
              price_gross:                 '3.5',
              price_vat:                   '0.25',
              price_vat_rate:              '7'
            },
            GT:       {
              server_ordering_serial:      '2012112900003',
              server_order_product_serial: '1211601',
              price_net:                   '6.51',
              price_gross:                 '7',
              price_vat:                   '0.49',
              price_vat_rate:              '7'
            }
          },
          order:        {
            ST_Adult: {
              rendered_ticket: Base64.encode64("https://xkcd.com/#{rand(1..2000)}/"),
              ticket_data:     {
                ticket_id:    '800001',
                ticket_type:  'Ticket',
                product_name: 'Single Ticket',
                price:        '5.0',
                vat_rate:     '7',
                currency:     'EUR'
              },
              aztec_content:   Base64.encode64("https://xkcd.com/#{rand(1..2000)}/")
            },
            ST_Child: {
              rendered_ticket: Base64.encode64("https://xkcd.com/#{rand(1..2000)}/"),
              ticket_data:     {
                ticket_id:    '800002',
                ticket_type:  'Ticket',
                product_name: 'Single Ticket',
                price:        '3.5',
                vat_rate:     '7',
                currency:     'EUR'
              },
              aztec_content:   Base64.encode64("https://xkcd.com/#{rand(1..2000)}/")
            },
            GT:       {
              rendered_ticket: Base64.encode64("https://xkcd.com/#{rand(1..2000)}/"),
              ticket_data:     {
                ticket_id:    '800001',
                ticket_type:  'Ticket',
                product_name: 'Group Ticket',
                price:        '7.5',
                vat_rate:     '7',
                currency:     'EUR'
              },
              aztec_content:   Base64.encode64("https://xkcd.com/#{rand(1..2000)}/")
            }
          }
        }
      end
    end
  end
end
