class MainController < ApplicationController
  def index
  end

  def upload
    puts params["file"]
    # byebug

    ret = 
    (
      begin
        case job_params["target"]
        when "0"
          print_by_zero
        when "1"
          print_by_one
        end
      rescue Exception
        nil
      end
    )

    if ret
      render json: {status: 'ok', ret: ret}
    else
      render json: {status: 'fail'}
    end
      
  end

  protected
    def job_params
      params["job"]
    end

    def print_by_zero
      uri = URI('http://print.darfux.cc/print')
      zpar = {
        file: File.new(params["file"].path),
        password: Settings.zero_printer_pwd
      }
      [:copy, :page].each do |key|
        v = job_params[key.to_s]
        zpar.merge!({key => v}) if v
      end
      resp = RestClient.post uri.to_s, zpar
    end
end
