class SentEmailsController < ApplicationController
  before_action :set_sent_email, only: %i[ show edit update destroy ]

  # GET /sent_emails or /sent_emails.json
  def index
    @sent_emails = SentEmail.all
  end

  # GET /sent_emails/1 or /sent_emails/1.json
  def show
  end

  # GET /sent_emails/new
  def new
    @sent_email = SentEmail.new
  end

  # GET /sent_emails/1/edit
  def edit
  end

  # POST /sent_emails or /sent_emails.json
  def create
    @sent_email = SentEmail.new(sent_email_params)

    respond_to do |format|
      if @sent_email.save
        format.html { redirect_to @sent_email, notice: "Sent email was successfully created." }
        format.json { render :show, status: :created, location: @sent_email }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sent_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sent_emails/1 or /sent_emails/1.json
  def update
    respond_to do |format|
      if @sent_email.update(sent_email_params)
        format.html { redirect_to @sent_email, notice: "Sent email was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @sent_email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sent_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sent_emails/1 or /sent_emails/1.json
  def destroy
    @sent_email.destroy!

    respond_to do |format|
      format.html { redirect_to sent_emails_path, notice: "Sent email was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_email
      @sent_email = SentEmail.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def sent_email_params
      params.expect(sent_email: [ :email, :subject, :body, :status, :message_id, :register_id ])
    end
end
