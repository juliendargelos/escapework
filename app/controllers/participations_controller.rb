class ParticipationsController < ApplicationController
    before_action { authorize only: :teacher }
    before_action :set_workshop, only: [:index, :new, :create]
    before_action :set_participation, only: [:destroy]

    def index
        @participations = @workshop.participations
        @participation = Participation.new workshop: @workshop
        @users = User.all
    end

    def create
        @participation = Participation.new participation_params.merge(workshop: @workshop)

        if @participation.save
            flash[:success] = 'La participation a bien été ajoutée'
            redirect_to participations_path(workshop_id: @workshop.id)
        else
            flash[:error] = 'Impossible d\'ajouter la participation'
            render :new
        end
    end

    def destroy
        @participation.destroy
        flash[:notice] = 'La participation a bien été supprimée'
        redirect_to participations_path(workshop_id: @participation.workshop.id)
    end

    private
        def set_workshop
            @workshop = Workshop.find params[:workshop_id]
        end

        def set_participation
            @participation = Participation.find params[:id]
        end

        def participation_params
            params.require(:participation).permit(:user_id)
        end
end
