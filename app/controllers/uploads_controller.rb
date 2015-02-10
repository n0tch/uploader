class UploadsController < ApplicationController
  before_action :find_uploads_name, only: [:index]
  before_action :find_upload_directory, only: [:index]
  $root = Dir.pwd + '/'
  $path_public = 'public/uploads/'
  # _____________________________________________________________________
  def index
    # @arquivos, carregado pelo before_action
    @path = $root + $path_public
  end
  # _____________________________________________________________________
  def new
  end
  # _____________________________________________________________________
  def create
    if File.extname(params[:doc].to_s) == '.exe'
      flash[:notice] = "Impossivel salvar arquivo executavel!"
    else
      save (params[:doc])
      flash[:notice] = "Uploaded! #{File.extname(params[:doc].to_s)}."
    end
    
    redirect_to root_path
  end
  # _____________________________________________________________________
  def download
    upload = params[:doc]
    send_file ($root +$path_public + upload)
    flash[:notice] = "Arquivo enviado!"
  end
  # _____________________________________________________________________
  def new_dir
    criar_pasta(params[:doc].to_s)
    # redirect_to root_path
  end
  # _____________________________________________________________________
  def remove_arquivo
    arquivo = params[:doc]
    File.delete($root +$path_public+arquivo)
    flash[:notice] = "Arquivo removido com sucesso!"
    redirect_to root_path
  end
  # _____________________________________________________________________
  def rename_file
    @arquivo = params[:doc].to_s
    @novo_nome = params[:new_file_name].to_s
    #render 'rename'
    File.rename(@arquivo, @novo_nome)
  end

  def edit
    #rename(params[:doc])
    @arquivo = params[:doc]
  end

  def troca_path
    $root = $root + params[:caminho]
  end

  private  #################### PRIVATE ####################

  def upload_params
    params.permit(:tipo)
  end

  def find_uploads_name
    @arquivos = []
    Dir.foreach($path_public) do |item|
      next if File.extname(item).to_s == "" # gambiarra para saber se o item e um diretorio olhando a extencao dele
      next if File.directory?(item) 
      @arquivos << item
    end
  end

  def find_upload_directory
    @paths = []
    Dir.foreach($root).sort.each do |item|
      if File.extname(item).to_s == ""
        @paths << item
      end
    end
  end

  def save(upload)
    File.open(Rails.root.join($root +$path_public, upload.original_filename), 'wb') do |file|
      file.write(upload.read)
    end
  end

  def criar_pasta(nome)
    Dir.mkdir($path_public+nome) unless File.exist?('public/uploads/'+nome)
  end
end