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

    def print_by_one
      printer_host = "http://p.newfuture.cc"

      doc = Nokogiri::HTML(open(printer_host))

      form_data = {
        '__VIEWSTATE': (doc/'#__VIEWSTATE').first['value'],
        '__VIEWSTATEGENERATOR': (doc/'#__VIEWSTATEGENERATOR').first['value'],
        '__EVENTVALIDATION': (doc/'#__EVENTVALIDATION').first['value'],
        'FileUpload': File.new(params["file"].path),
        pwdTextBox: Settings.one_printer_pwd,
        copy: 1,
        button: 'ruaruarua'
      }

      if page = job_params['page']
        form_data.merge!({rangeInput: page})
      end

      if copy = job_params['copy']
        form_data.merge!({copy: copy})
      end

      resp = RestClient.post printer_host, form_data

      unless resp.body.match "已经添加"
        return nil
      end
      
      return resp.code.to_s
    end
end
