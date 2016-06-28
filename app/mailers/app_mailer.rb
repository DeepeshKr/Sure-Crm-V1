class AppMailer < ApplicationMailer
  default from: 'noreply@hbnindia.com'

  def new_ticket(email_id, app_feature_request)
    @app_feature_request = app_feature_request
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_request.id}"
    mail(to: email_id, subject: "New ticket created with Ref no #{app_feature_request.id}")
  end

  def new_comment(email_id, app_feature_comment)
    @app_feature_comment = app_feature_comment
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_comment.app_feature_request_id}"
    mail(to: email_id, subject: "New comment for #{app_feature_comment.app_feature_request_id}")
  end

  def updated(email_id,app_feature_request)
    @app_feature_request = app_feature_request
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_request.id}"
    mail(to: email_id, subject: "Ticket no #{app_feature_request.id} is now #{app_feature_request.app_status.name}")
  end

  def upload(email_id,app_feature_request)
    @app_feature_request = app_feature_request
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_request.id}"
    mail(to: email_id, subject: "Ticket no #{app_feature_request.id} is now #{app_feature_request.app_status.name}")
  end

  def check(email_id,app_feature_request)
    @app_feature_request = app_feature_request
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_request.id}"
    @test_url = "http://3.0.3.26:120"
    mail(to: email_id, subject: "Ticket no #{app_feature_request.id} is now #{app_feature_request.app_status.name}")
  end

  def feature_live(email_id,app_feature_request)
    @app_feature_request = app_feature_request
    @feature_comments = AppFeatureComment.where(app_feature_request_id: app_feature_request.id, display_level_id: 10000)
    @url  = "http://3.0.3.57/app_feature_requests/#{app_feature_request.id}"
    @test_url = "http://3.0.3.26:120"
    mail(to: email_id, subject: "Ticket no #{app_feature_request.id} is now #{app_feature_request.app_status.name}")
  end

  def test_email(email_id, app_feature_request)
    @app_feature_request = app_feature_request
    @url  = "http://3.0.3.57/app_feature_requests/"
    mail(to: email_id, subject: "Welcome")
  end
end
