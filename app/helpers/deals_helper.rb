module DealsHelper
  # This method helps create another new set of form via jQuery. Linked to assets/javascripts/deal.js.coffee
  def link_to_add_day(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("form/deal_day_form", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  # This method helps create another new set of form via jQuery. Linked to assets/javascripts/deal.js.coffee
  def link_to_add_time(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("form/deal_time_form", f: builder)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
