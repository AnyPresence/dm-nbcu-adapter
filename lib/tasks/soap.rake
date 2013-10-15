namespace :soap do
  desc "generates client files based on a wsdl"
  task :generate, :wsdl_path, :file_path, :module_name do |t, args|
    puts args.inspect
    require 'wsdl/soap/wsdl2ruby'
    wsdl2ruby          = WSDL::SOAP::WSDL2Ruby.new
    wsdl2ruby.logger   = $LOG if $LOG
    wsdl2ruby.location = args[:wsdl_path]
    wsdl2ruby.basedir  = "/tmp/omg/sample.wsdl/"

    wsdl2ruby.opt.merge!({
      'classdef'         => "Test",
      'module_path'      => "Test",
      'mapping_registry' => nil,
      'driver'           => nil,
      'client_skelton'   => nil,
    })
    
    wsdl2ruby.run
  end
end