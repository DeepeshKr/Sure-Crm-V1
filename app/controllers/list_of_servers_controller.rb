class ListOfServersController < ApplicationController
  before_action :set_list_of_server, only: [:show, :edit, :update, :destroy]

  # GET /list_of_servers
  # GET /list_of_servers.json
  def index
    @list_of_servers = ListOfServer.all
  end

  # GET /list_of_servers/1
  # GET /list_of_servers/1.json
  def show
  end

  # GET /list_of_servers/new
  def new
    @list_of_server = ListOfServer.new
  end

  # GET /list_of_servers/1/edit
  def edit
  end

  # POST /list_of_servers
  # POST /list_of_servers.json
  def create
    @list_of_server = ListOfServer.new(list_of_server_params)

    respond_to do |format|
      if @list_of_server.save
        format.html { redirect_to @list_of_server, notice: 'List of server was successfully created.' }
        format.json { render :show, status: :created, location: @list_of_server }
      else
        format.html { render :new }
        format.json { render json: @list_of_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /list_of_servers/1
  # PATCH/PUT /list_of_servers/1.json
  def update
    respond_to do |format|
      if @list_of_server.update(list_of_server_params)
        format.html { redirect_to @list_of_server, notice: 'List of server was successfully updated.' }
        format.json { render :show, status: :ok, location: @list_of_server }
      else
        format.html { render :edit }
        format.json { render json: @list_of_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_of_servers/1
  # DELETE /list_of_servers/1.json
  def destroy
    @list_of_server.destroy
    respond_to do |format|
      format.html { redirect_to list_of_servers_url, notice: 'List of server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list_of_server
      @list_of_server = ListOfServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def list_of_server_params
      params.require(:list_of_server).permit(:name, :description, :active_since, :internal_ip, :vpn_ip, :external_ip, :current_status)
    end
end
