locals {
  transit_gateway_route_table_association = distinct(compact(flatten(
    [for route_table in var.transit_gateway_route_table :
      [for association in route_table.transit_gateway_route_table_associations :
        {
          identifier                   = join("_", [route_table.identifier, association])
          tgw_route_table_identifier   = route_table.identifier
          tgw_attachment_identifier    = association
          replace_existing_association = route_table.replace_existing_association
        }
      ]
    ]
  )))

  transit_gateway_route_table_propagation = distinct(compact(flatten(
    [for route_table in var.transit_gateway_route_table :
      [for propagation in route_table.transit_gateway_route_table_propagations :
        {
          identifier                 = join("_", [route_table.identifier, propagation])
          tgw_route_table_identifier = route_table.identifier
          tgw_attachment_identifier  = propagation
        }
      ]
    ]
  )))
}