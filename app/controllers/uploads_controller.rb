class UploadsController < ApplicationController
  before_action :find_uploads_file, :find_upload_directory, only: [:index]

  def initialize
    $root =  Dir.pwd+'/'
    # session[:current_user] = num + Random.rand(10)
  end
  
  def index
    #controller para criar view
  end

  def new
    @arquivos = []
  end

  def create
      if params[:array].nil?
        flash[:notice] = 'Arquivo vazio.'
      else
        params[:array].each do |arquivo|
          next if File.extname(arquivo.original_filename) == '.exe'
          save(arquivo)
        end
          flash[:notice] = 'Arquivo(s) salvo(s)!'
      end
    redirect_to root_path
  end
  
  def download
    send_file ($root + params[:doc])
    flash[:notice] = 'Arquivo #{params[:doc]} enviado!'
  end

  def new_dir
    # controller para criar a view
  end
  
  def cria_pasta
    criar_pasta(params[:doc].to_s, params[:leitura].to_i, params[:escrita].to_i)
    redirect_to root_path
  end
  
  def remove_arquivo
    if File.extname(params[:doc].to_s) == ""
      flash[:notice] = "Diretorio '#{params[:doc]}' removido."
      deletar_pasta(params[:doc].to_s)
    else
      flash[:notice] = "Arquivo '#{params[:doc]}' removido."
      File.delete($root + params[:doc].to_s)
    end
    redirect_to root_path
  end
  
  def troca_caminho
    require 'fileutils'
    FileUtils.cd($root+params[:caminho]+ '/', :verbose => true)
    redirect_to root_path
  end

  def show
    @texto = []
    f = File.open($root+params[:doc], 'r')
    f.each_line do |line|
      # line.replace("<br>", "")
      # line.gsub(/,/, "<br/>")
      next if line.chomp("\n") == ''
      @texto << line.chomp("\n")
    end
    f.close
  end

  def delete_checkbox
    flash[:notice] = "Passou aqui!!! #{params[:delete]}"
    redirect_to root_path
  end
  
  def download_zip
    #TERMINAR
    filename = "LANG_SOFT#{Time.now}.zip"
    temp_file = Tempfile.new(filename)
    
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip_file|
        #put files in here
        Dir.foreach(Dir.pwd) do |pasta|
          if File.directory?(pasta)
            Dir.foreach(pasta) do |subpasta1|
              if File.file?(subpasta1)
                zip_file.add(subpasta1, $root + pasta + subpasta1)
              end
            end
          else
            zip_file.add(pasta, $root + pasta)
          end
        end
    end
    zip_data = File.read(temp_file.path)
    send_data(zip_data, :type => 'application/zip', :filename => filename)
  end

  def rename_file
    
  end

  def login
    
  end

  def autenticar
    require 'bcrypt'
    user = BCrypt::Password.create("123456789")
    pass = BCrypt::Password.create("987654321")
    if user == params[:username] and pass == params[:senha]
      flash[:notice] = "Entrou"
      redirect_to root_path
    else
      flash[:notice] = "Errada || #{params[:senha]}"
      render 'uploads/login'
    end
  end

  private  #################### PRIVATE ####################

  def find_uploads_file
    @arquivos = []
    Dir.foreach($root) do |item|
      if File.file?(item)
        @arquivos << item
      end
    end
  end

  def find_upload_directory
    @paths = []
    Dir.foreach($root).sort.each do |item|
      if File.directory?(item)
        @paths << item
      end
    end
  end

  def save(upload)
    File.open(Rails.root.join($root, upload.original_filename), 'wb') do |file|
      file.write(upload.read)
    end
    FileUtils.chmod(0777 , $root + upload.original_filename, :verbose => true)
  end

  def criar_pasta(nome, leitura, escrita)
    Dir.mkdir($root+nome) unless File.exist?($root+nome)
    if leitura == 1 and escrita == 1
      FileUtils.chmod(0666, $root+nome, :verbose => true)
    elsif leitura == 1 and escrita == 0
      FileUtils.chmod(0444, $root+nome, :verbose => true)
    elsif leitura == 0 and escrita == 1
      FileUtils.chmod(0222, $root+nome, :verbose => true)
    else
      FileUtils.chmod(0000, $root+nome, :verbose => true)
    end
  end

  def deletar_pasta(nome)
    require 'fileutils'
    FileUtils.rm_rf(nome)
  end

end