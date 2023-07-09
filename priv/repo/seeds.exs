# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     JobBoard.Repo.insert!(%JobBoard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias JobBoard.Accounts.User
alias JobBoard.Jobs.{Category, Listing}
alias JobBoard.Repo

elixir_category = %Category{
  id: 1,
  name: "Elixir Developer"
}

phoenix_full_stack = %Category{
  id: 2,
  name: "Phoenix Full Stack"
}

testing_and_qa_category = %Category{
  id: 3,
  name: "Testing + QA"
}

Repo.insert!(elixir_category)
Repo.insert!(phoenix_full_stack)
Repo.insert!(testing_and_qa_category)

demo_job_1 = %Listing{
  id: 1,
  title: "Demo Job 1",
  description: "Open position at Demo Company.\n\nThis is a demo listing.",
  category_id: 1,
  company_name: "Demo Company",
  company_web_url: "https://google.com/"
}

demo_job_2 = %Listing{
  id: 2,
  title: "Demo Job 2",
  description: "Test description for job listing 2.",
  category_id: 2,
  company_name: "II Test Co.",
  company_web_url: "https://google.com/"
}

Repo.insert!(demo_job_1)
Repo.insert!(demo_job_2)
