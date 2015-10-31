class PlanService

  module ClassMethods

    def get_plan_names(plan_id = 1)
      plan_name = Plan.find(plan_id).name
    end

    def get_addon_names(addon_id)
      addon_names = AddOn.find(addon_id).name
    end

    def get_addon_ids(plan_id)
      plan = Plan.find(plan_id)
      plan.add_ons.pluck(:id)
    end

  end

  class << self
    include ClassMethods
  end
end
