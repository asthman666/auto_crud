package Auto::CRUD;
use Mojo::Base 'Mojolicious';
use Mojo::Log;
use Mojo::mysql;

# This method will run once at server start
sub startup {
  my $self = shift;

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  $self->plugin('Config');
  $self->plugin('DefaultHelpers');

  $self->app->log(Mojo::Log->new);

  $self->helper(
      mysql => sub { Mojo::mysql->new('mysql://' . $self->config->{db_user} . ':' . $self->config->{db_password} . '@localhost/ptt')->options({mysql_enable_utf8 => 1}) }
      );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  #$r->get('/')->to('example#welcome');
  $r->get('/admin/:table/read.json')->to('admin#api_read');
  $r->post('/admin/:table/create.json')->to('admin#api_create');
  $r->post('/admin/:table/update.json')->to('admin#api_update');
  $r->post('/admin/:table/delete.json')->to('admin#api_delete');
  $r->get('/admin/:table')->to('admin#read');
  #$r->get('/admin/site')->to('admin-site#read');
  #$r->post('/admin/site/create.json')->to('admin-site#api_create');
  #$r->get('/admin/site/read.json')->to('admin-site#api_read');
  #$r->post('/admin/site/update.json')->to('admin-site#api_update');
  #$r->post('/admin/site/delete.json')->to('admin-site#api_delete');
}

1;
