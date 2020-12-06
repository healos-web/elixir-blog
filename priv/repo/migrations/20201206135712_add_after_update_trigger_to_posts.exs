defmodule Blog.Repo.Migrations.AddAfterUpdateTriggerToPosts do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION set_published_at() RETURNS trigger AS
      $$
      BEGIN
        NEW.published_at := current_timestamp;
        RETURN NEW;
      END
      $$
      LANGUAGE plpgsql;
    """

    execute """
      CREATE TRIGGER before_update_posts BEFORE UPDATE
      ON posts
      FOR EACH ROW
      WHEN (OLD.status != 'published' AND NEW.status = 'published')
      EXECUTE PROCEDURE set_published_at();
    """
  end

  def down do
    execute "DROP TRIGGER before_update_posts ON posts;"
    execute "DROP FUNCTION set_published_at();"
  end
end
