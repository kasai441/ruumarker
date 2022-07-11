# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'Ruumarkar',
      title: '入居時チェック表',
      reverse: true,
      charset: 'utf-8',
      description: '引っ越しをしたらすぐに、壁や床のキズや汚れを入居時チェック表にまとめて、大家さんに提出しましょう。',
      keywords: '不動産, 賃貸, 引っ越し, 原状回復義務, 修繕費',
      # canonical: request.original_url,
      separator: '|',
      icon: [
        # { href: image_url('favicon.ico') },
        # { href: image_url('icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        # image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary',
        site: '@kasai441',
      }
    }
  end
end
