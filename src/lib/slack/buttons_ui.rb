module Slack

  class ButtonsUI

    ENVS_PRIO = %w(dev development staging demo pentest preprod prod production)

    # change params names - section name / buttons info

    def self.display(deployer_config:)
      value = new.display deployer_config: deployer_config
      value
    end

    def display(deployer_config:)
      generate_panels deployer_config: deployer_config
    end

    def generate_panels(deployer_config:)
      config = deployer_config
      panels = []
      idx = 0
      config.each do |stack_name, deploy_targets|
        panel = generate_buttons_row stack_name: stack_name, deploy_targets: deploy_targets, panel_idx: idx
        idx += 1
        panels.push panel
      end
      panels.sort_by!{ |panel| panel.f :text }
      panels
    end

    # def generate_panel(section_name:, button_infos:, panel_idx:)
    #   button_rows = []
    #   button_infos.each do |stack_name, deploy_targets|
    #     button_row = generate_buttons_row stack_name: stack_name, deploy_targets: deploy_targets, panel_idx: panel_idx
    #     button_rows.push button_row
    #   end
    #   button_rows
    # end

    def generate_buttons_row(stack_name:, deploy_targets:, panel_idx:)
      buttons = []
      # todo: move colors in configs
      colors = ["#323C8C", "#775500", "#1d4482", "#AA2299", "#00AADD", "#BBBBBB"]
      color = colors[panel_idx] || "#999999"
      deploy_targets.each do |deploy_target_name, deploy_target|
        env_tag = deploy_target.f :env_tag
        project = deploy_target.f :project
        button  = generate_button env_tag: env_tag, project: project, deploy_target: deploy_target
        buttons.push button unless [:production, :prod, :"sd-02"].include? env_tag
      end
      # TODO: sort by ENVS_PRIO index
      # buttons.sort_by!{ |button| button.f :xxx }
      {
        text: "#{stack_name.to_s.capitalize}:",
        fallback: "",
        callback_id: "deployment-ab-kube-dev",
        color: color,
        attachment_type: "default",
        actions: buttons,
        # confirm: SlackConfirm, # TODO: confirm for staging envs
      }
    end

    def generate_button(env_tag:, project:, deploy_target:)
      {
        name: "environment-#{project}-#{env_tag}",
        text: env_tag.to_s.capitalize,
        value: env_tag,
        type: "button",
      }
    end

  end

end
