#!/usr/bin/ruby

require 'gtk'

main_win = Gtk::Window.new(Gtk::WINDOW_TOPLEVEL)
main_win.signal_connect("destroy") { exit }
main_win.show
label = Gtk::Label.new("‚±‚ñ‚É‚¿‚Í")
main_win.add(label)
label.show
main_win.show
Gtk.main
