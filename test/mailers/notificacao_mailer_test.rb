require 'test_helper'

class NotificacaoMailerTest < ActionMailer::TestCase
  test "novo_forum" do
    mail = NotificacaoMailer.novo_forum
    assert_equal "Novo forum", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "nova_reuniao" do
    mail = NotificacaoMailer.nova_reuniao
    assert_equal "Nova reuniao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "adiar_reuniao" do
    mail = NotificacaoMailer.adiar_reuniao
    assert_equal "Adiar reuniao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "confirmar_reuniao" do
    mail = NotificacaoMailer.confirmar_reuniao
    assert_equal "Confirmar reuniao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "cancelar_reuniao" do
    mail = NotificacaoMailer.cancelar_reuniao
    assert_equal "Cancelar reuniao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "reativar_reuniao" do
    mail = NotificacaoMailer.reativar_reuniao
    assert_equal "Reativar reuniao", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
