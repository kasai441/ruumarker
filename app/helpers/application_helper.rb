# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags # rubocop:disable Metrics/MethodLength
    {
      site: 'Ruumarkar',
      title: '引っ越し時のキズ・汚れのチェック表作成サービス',
      reverse: true,
      charset: 'utf-8',
      description: '引っ越しをしたらすぐに、壁や床のキズや汚れを入居時チェック表にまとめて、大家さんに提出しましょう。',
      keywords: '不動産, 賃貸, 引っ越し, 原状回復義務, 修繕費',
      # canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('logo.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary',
        site: '@kasai441',
        domain: request.original_url,
        title: :title,
        description: :description,
        image: image_url('logo.png')
      }
    }
  end
end
