package GetNum;

use strict;
use warnings;
use Inline 'C' => <<'EOC';
#include <stdlib.h>

SV* coerce_num_string(SV* sv, int iType) {
    if(SvOK(sv) == 0 || SvPOK(sv) == 0) {
        return( NULL );
    }

    STRLEN len;
    errno = 0;
    char *endptr;
    char *str = SvPV(sv,len);

    double iSV = strtod( str, &endptr );
    if(errno != 0 || endptr == str) {
        return( NULL );
    }
    
    if(iType == 1) {
        return( newSViv( iSV ) );
    }
    else {
        return( newSVnv( iSV ) );
    }
}

SV* get_int(SV* sv) {
    if(SvIOK(sv) != 0 || SvNOK(sv) != 0) {
        return( newSViv( SvIV(sv) ) );
    }
    else if(SvPOK(sv) != 0) {
        return( coerce_num_string(sv,1) );
    }
    else {
        return( NULL );
    }
}

SV* get_float(SV* sv) {
    if(SvNOK(sv) != 0 || SvIOK(sv) != 0) {
        return( newSVnv( SvNV(sv) ) );
    }
    else if(SvPOK(sv) != 0) {
        return( coerce_num_string(sv,2) );
    }
    else {
        return( NULL );
    }
}

int is_int(SV* sv) {
    return SvIOK(sv);
}

int is_float(SV* sv) {
    return SvNOK(sv);
}
EOC

use parent qw(Exporter);
our @EXPORT = qw(get_int is_int is_float get_float);

use version; our $VERSION = qv(1.0.0);

1;
