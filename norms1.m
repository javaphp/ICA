function cvx_optval = norms( x, p, dim )
error( nargchk( 1, 3, nargin ) ); %#ok
if nargin < 2 || isempty( p ),
    p = 2;
elseif ~isnumeric( p ) || numel( p ) ~= 1 || ~isreal( p ),
    error( 'Second argument must be a real number.' );
elseif p < 1 || isnan( p ),
    error( 'Second argument must be between 1 and +Inf, inclusive.' );
end
    
sx = size( x );
if nargin < 3 || isempty( dim ),
    dim = cvx_default_dimension( sx );
%elseif ~cvx_check_dimension( dim, false ),
%    error( 'Third argument must be a valid dimension.' );
elseif isempty( x ) || dim > length( sx ) || sx( dim ) == 1,
    p = 1;
end
switch p,
    case 1,
        cvx_optval = sum( abs( x ), dim );
    case 2,
        cvx_optval = sqrt( sum( x .* conj( x ), dim ) );
    case Inf,
        cvx_optval = max( abs( x ), [], dim );
    otherwise,
        cvx_optval = sum( abs( x ) .^ p, dim ) .^ ( 1 / p );
end