class InvitationsController < ApplicationController

	respond_to :html, :json
	def index
		@invitations = current_user.invitations
		respond_with @invitations
	end
		
	def new
		@invitation = Invitation.new
		respond_with @invitation
	end

	def create
		params[:invitation][:user_id] = current_user.id
		params[:invitation][:auth_token] = SecureRandom.hex	
		@invitation = Invitation.new(params_invitations)
		@base_url = request.host_with_port
		UserMailer.invitation(params[:invitation][:email],params[:invitation][:auth_token],@base_url ).deliver
		flash[:notice] = "Invitation was successfully created." if @invitation.save
		respond_with @invitation
	end

	def show
		@invitation = Invitation.find params[:id]
		respond_with @invitation
	end	

	def edit
		@invitation = Invitation.find params[:id]
		respond_with @invitation
	end

	def update
		@invitation = Invitation.find(params[:id])
    flash[:notice] = 'Invitation was successfully updated.' if @invitation.update(params_invitations)
    respond_with @invitation
	end

	def destroy
		@invitation = Invitation.find(params[:id])
    respond_with @invitation.destroy
	end	

	private

	def params_invitations
		params.require(:invitation).permit(:email, :role, :user_id, :auth_token)
	end	
end
