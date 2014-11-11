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

sub api_create {
    my $self = shift;
    my $site_id = $self->param("site_id");

    my $info;

    my @k = ("site_name", "domain", "track_url");
    push @k, "site_id" if $site_id;
    
    my @v;
    foreach ( @k ) {
        push @v, $self->param($_);
    }
    
    push @k, ("dt_created", "dt_updated");
    push @v, ("now()", "now()");
    
    my $query = "insert into site (" . join(",", @k) . ") values (" . join(",", ("?")x@v ) . ")";
    $self->mysql->db->query($query, @v);

    $info->{code} = 1;
}

sub api_update {
    my $self = shift;
    my $site_id     = $self->param("site_id");
    my $info;
    $info->{code} = 0;

    if ( $site_id ) {
        my $domain = $self->param("domain");
        my $query = "update site set domain = ?, dt_updated = now() where site_id = ?";
        $self->mysql->db->query($query, $domain, $site_id);
        $info->{code} = 1;
    }

    $self->render(json => $info);
}

sub api_delete {
    my $self = shift;
    my $site_id = $self->param("site_id");
    my $info;
    $info->{code} = 0;

    if ( $site_id ) {
        my $query = "delete from site where site_id = ?";
        $self->mysql->db->query($query, $site_id);
        $info->{code} = 1;
    }

    $self->render(json => $info);
}

1;
