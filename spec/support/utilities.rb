module SpecUtilities
  def login_user(user)
    cookies.permanent.signed[:user_id] = user.id
  end

  def get_login_params(email, password)
    {
      user: {
        email: email,
        password: password
      }
    }
  end

  def get_bookmark_params
    {
      bookmark: {
        title: "Bookmark",
        url: "http://google.de/abcd",
        shortening: "BKK",
        all_tags: ""
      }
    }
  end
end
