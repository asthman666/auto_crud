package Auto::CRUD::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';

sub read {
  my $self = shift;
  my $table = $self->param('table');
  
  my @rows = $self->mysql->db->query("desc $table")->hashes->each;
  
  my ($db_fields, $delete_key_db_fields, $default_sort_field, $default_sort_order);
  foreach ( @rows ) {
      push @$db_fields, $_->{Field};
      if ( $_->{Key} eq "PRI" ) {
          push @$delete_key_db_fields, $_->{Field};
          $default_sort_field ||= $_->{Field};
      }
  }
  
  $self->render(
      table                   => $table,
      db_fields               => $db_fields,
      no_insert_db_fields     => ['active', 'dt_created', 'dt_updated'],
      delete_key_db_fields    => $delete_key_db_fields,
      default_sort_field      => $default_sort_field,
      default_sort_order      => 'desc',
      );
}

sub api_read {
    my $self = shift;
    my $table = $self->param("table");

    my $offset  = $self->param("offset");
    my $limit   = $self->param("limit");
    my $sort    = $self->param("sort");
    my $order   = $self->param("order");
    my $search  = $self->param("search");

    my $info;
    
    my $where = "";
    if ( $search ) {
	#$where = " where site_id like '$search%'"
    }
    
    my $query = "select * from $table $where order by $sort $order limit $offset, $limit";
    @{$info->{rows}} = $self->mysql->db->query($query)->hashes->each;
    
    $query = "select count(*) from $table $where";
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
    
    my $query = "insert into site (" . join(",", @k) . ") values (" . join(",", ("?")x@v ) . ", now(), now())";
    $self->mysql->db->query($query, @v);

    $info->{code} = 1;
    $self->render(json => $info);
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
