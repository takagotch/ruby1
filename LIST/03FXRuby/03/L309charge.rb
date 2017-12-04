#!/usr/local/bin/ruby -Ku

require "fox"
require "fox/responder"

include Fox

class ChargeWindow < FXMainWindow
  include Responder

  ID_CHARGE_CLICK, ID_LAST = enum(FXMainWindow::ID_LAST, 2)

  def initialize(app)
    super(app, "341S�[�d�c�[��", nil, nil, DECOR_ALL)

    FXButton.new(self, "�[�d�J�n", nil, self, ID_CHARGE_CLICK, 
		 BUTTON_NORMAL | LAYOUT_SIDE_LEFT)
    FXButton.new(self, "�I��", nil, app, FXApp::ID_QUIT, BUTTON_NORMAL)

    FXMAPFUNC(SEL_COMMAND, ID_CHARGE_CLICK, "onChargeClick")
    @fp = nil
  end

  def onChargeClick(sender, sel, ev)
    if @fp
      @fp.close
      @fp = nil
      sender.text = "�[�d�J�n"
    else
      @fp = File.open("COM4:")
      sender.text = "�[�d���f"
    end
  end
end

## AppName, VendorName
application = Fox::FXApp.new("PCCCharge", "taka-hr.dhis.portside.net")
application.init(ARGV)

main = ChargeWindow.new(application)

application.create()
main.show(Fox::PLACEMENT_SCREEN)
application.run()
