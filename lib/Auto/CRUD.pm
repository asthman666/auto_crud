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


  $self->app->log(Mojo::Log->new);

  $self->helper(
      mysql => sub { Mojo::mysql->new('mysql://' . $self->config->{db_user} . ':' . $self->config->{db_password} . '@localhost/ptt')->options({mysql_enable_utf8 => 1}) }
      );

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
  $r->get('/admin/site')->to('admin-site#read');
  $r->get('/admin/site/read.json')->to('admin-site#api_read');
  $r->get('/admin/review')->to('admin-review#read');
  $r->get('/admin/review/read.json')->to('admin-review#api_read');
}

1;
