package Auto::CRUD::Controller::Admin::Review;
use Mojo::Base 'Mojolicious::Controller';

sub read {
  my $self = shift;
  $self->render(title => 'Review');
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
	$where = " where review_id like '$search%'"
    }
    
    my $query = "select * from review $where order by $sort $order limit $offset, $limit";
    @{$info->{rows}} = $self->mysql->db->query($query)->hashes->each;
    
    $query = "select count(*) from review $where";
    $info->{total} = $self->mysql->db->query($query)->array->[0];

    $self->render(json => $info);
}

1;
