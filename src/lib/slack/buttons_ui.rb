module Slack

  class ButtonsUI

    def self.display
      new.display
    end

    def display
      generate_buttons
    end

    def generate_buttons
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

    def generate_button_row(section_name, button_infos, idx)
      buttons = []
      colors = ["#323C8C", "#775500", "#1d4482", "#AA2299", "#00AADD", "#BBBBBB"]
      color = colors[idx] || "#999999"
      button_infos.each do |deploy_target_env, deploy_target|
        button = SlackGenerateButton.(deploy_target_env, deploy_target)
        buttons.push button unless [:production, :prod, :"sd-02"].include? deploy_target_env
      end
      # buttons.sort_by!{ |button| button.fetch :xxx }
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

    def generate_button

    end

  end
