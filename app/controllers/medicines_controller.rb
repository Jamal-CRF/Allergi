class MedicinesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_allergies, only: %i[show emergency]

  def index
    if params[:query].present?
      sql_query = "name ILIKE :query OR principle ILIKE :query OR laboratory ILIKE :query"
      @medicines = Medicine.where(sql_query, query: "%#{params[:query]}%")
    else
      @medicines = Medicine.all
    end
  end

  def show
    @reactions = Medicine.where(principle: @medicine.principle).map { |medicine| medicine.allergies.where(user: current_user).map{ |u| u.reactions }}.flatten
  end

  def create
  end

  def destroy
  end

  def emergency
    @appointment = current_user.appointments.last
    @reactions = Medicine.where(principle: @medicine.principle).map { |medicine| medicine.allergies.where(user: current_user).map{ |u| u.reactions }}.flatten
  end

  private

  def set_allergies
    @medicine = Medicine.find(params[:id])
    @allergies = Allergy.includes(:reactions).where(user: current_user, medicine: @medicine)
  end
end
