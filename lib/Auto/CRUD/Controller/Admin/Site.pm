package Auto::CRUD::Controller::Admin::Site;
use Mojo::Base 'Mojolicious::Controller';

sub read {
  my $self = shift;
  $self->render(title => 'Site');
}

sub api_read {
    my $self = shift;

    my $offset  = $self->param("offset");
    my $limit   = $self->param("limit");
    my $sort    = $self->param("sort");
    my $order   = $self->param("order");
    my $search  = $self->param("search");

    my $info;
    
    my $where = "";
    if ( $search ) {
	$where = " where site_id like '$search%'"
    }
    
    my $query = "select * from site $where order by $sort $order limit $offset, $limit";
    @{$info->{rows}} = $self->mysql->db->query($query)->hashes->each;
    
    $query = "select count(*) from site $where";
    $info->{total} = $self->mysql->db->query($query)->array->[0];

    $self->render(json => $info);
}

1;
