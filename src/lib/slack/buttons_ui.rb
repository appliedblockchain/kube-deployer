module Slack

  class ButtonsUI

    # change params names - section name / buttons info
    
    def self.display(stack_name:, deploy_targets:)
      new.display(stack_name: stack_name, deploy_targets: deploy_targets)
    end

    def display(deployer_config:)
      generate_panels deployer_config: deployer_config
    end

    def generate_panels(deployer_config:)
      panels = []

      config = deployer_config
      idx = 0
      config.each do |stack_name, deploy_targets|
        panel = generate_buttons stack_name: stack_name, deploy_targets: deploy_targets, idx: idx
        panels.push panel
        idx += 1
      end
      panels.sort_by!{ |panel| panel.fetch :text }

      panels
    end

    def generate_buttons(stack_name:, deploy_targets:)
      section_name = stack_name
      button_infos = deploy_targets
      panel = []
      idx = 0
      config.each do |section_name, button_infos|
        button = generate_button_row section_name: section_name, button_infos: button_infos, idx: idx
        panel.push button
        idx += 1
      end

      panel
    end

    def generate_button_row(section_name:, button_infos:, idx:)
      buttons = []
      # todo: move colors in configs
      colors = ["#323C8C", "#775500", "#1d4482", "#AA2299", "#00AADD", "#BBBBBB"]
      color = colors[idx] || "#999999"
      button_infos.each do |deploy_target_env, deploy_target|
        button = generate_button deploy_target_env:  deploy_target_env, deploy_target: deploy_target
        buttons.push button unless [:production, :prod, :"sd-02"].include? deploy_target_env
      end
      # buttons.sort_by!{ |button| button.f :xxx }
      {
        text: "#{section_name.to_s.capitalize}:",
        fallback: "",
        callback_id: "deployment-ab-dev",
        color: color,
        attachment_type: "default",
        actions: buttons,
        # confirm: SlackConfirm, # TODO: confirm for staging envs
      }
    end

    def generate_button(deploy_target_env:, deploy_target:)
      stack_name = deploy_target.fetch :stack_name
      {
        name: "environment-#{stack_name}",
        text: deploy_target_env.to_s.capitalize,
        value: deploy_target_env,
        type: "button",
      }
    end

  end
