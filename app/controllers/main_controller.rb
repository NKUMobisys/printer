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
      [:copy, :page, :double_sides].each do |key|
        v = job_params[key.to_s]
        zpar.merge!({key => v}) if v && v!="false"
      end
      resp = RestClient.post uri.to_s, zpar
    end

    # JAVA api by sunjian
    def print_by_one
      printer_host = "http://6.p.smartlife.space:8080/printer/print"

      form_data = {
        'file': File.new(params["file"].path),
        password: 'RUARUARUA',
        copies: 1,
      }

      if page = job_params['page']
        form_data.merge!({range: page})
      end

      if copy = job_params['copy']
        form_data.merge!({copies: copy})
      end

      resp = RestClient.post printer_host, form_data

      unless resp.body.match "true"
        return nil
      end

      return resp.code.to_s
    end

    # .NET api by NewFuture
    def print_by_one_old
      printer_host = "http://6.p.newfuture.win"

      # doc = Nokogiri::HTML(open(printer_host))

      form_data = {
        # '__VIEWSTATE': (doc/'#__VIEWSTATE').first['value'],
        # '__VIEWSTATEGENERATOR': (doc/'#__VIEWSTATEGENERATOR').first['value'],
        # '__EVENTVALIDATION': (doc/'#__EVENTVALIDATION').first['value'],
        'files': File.new(params["file"].path),
        password: 'NewFuture',
        copies: 1,
        button: 'ruaruarua'
      }

      if page = job_params['page']
        form_data.merge!({range: page})
      end

      if copy = job_params['copy']
        form_data.merge!({copies: copy})
      end

      resp = RestClient.post printer_host, form_data



      unless resp.body.match "已添加"
        return nil
      end

      return resp.code.to_s
    end
end
