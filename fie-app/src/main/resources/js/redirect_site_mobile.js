��/ * 
 i f   ( ( n a v i g a t o r . u s e r A g e n t . i n d e x O f ( ' i P h o n e ' )   ! =   - 1   | |   n a v i g a t o r . u s e r A g e n t . i n d e x O f ( ' A n d r o i d ' )   ! =   - 1 )   & &   L i r e C o o k i e ( " F T V m o b i l e _ r e d i r e c t " ) ! = " n o n " )   { 
         i f   ( c o n f i r m ( " S o u h a i t e z - v o u s   a c c � d e r   a u   s i t e   i n t e r n e t   d e   F r a n c e   T � l � v i s i o n s   a d a p t �   a u x   m o b i l e s ? " ) )   { 
                 d o c u m e n t . l o c a t i o n   =   " h t t p : / / m . f r a n c e t v . f r " ; 
         } e l s e { 
                 e x p i r a t i o n _ c o o k i e = n e w   D a t e ; 
                 e x p i r a t i o n _ c o o k i e . s e t M o n t h ( e x p i r a t i o n _ c o o k i e . g e t M o n t h ( ) + 1 ) ; 
                 E c r i r e C o o k i e ( " F T V m o b i l e _ r e d i r e c t " ,   " n o n " ,   e x p i r a t i o n _ c o o k i e ) ; 
         } 
 } 
 i f   ( ( n a v i g a t o r . u s e r A g e n t . i n d e x O f ( ' i P a d ' ) ! = - 1 )   & &   L i r e C o o k i e ( " F T V m o b i l e _ r e d i r e c t _ i p a d " ) ! = " n o n " )   { 
         i f   ( c o n f i r m ( " N o u v e a u   ! \ n S o u h a i t e z - v o u s   a c c e d e r   a u   s i t e   R o l a n d - G a r r o s   a d a p t �   �   l ' i P a d ? \ n \ n h t t p : / / m . f r a n c e t v . f r / i p a d / " ) )   { 
                 d o c u m e n t . l o c a t i o n   =   " h t t p : / / m . f r a n c e t v . f r / i p a d / " ; 
         } e l s e { 
                 e x p i r a t i o n _ c o o k i e = n e w   D a t e ; 
                 e x p i r a t i o n _ c o o k i e . s e t M o n t h ( e x p i r a t i o n _ c o o k i e . g e t M o n t h ( ) + 1 ) ; 
                 E c r i r e C o o k i e ( " F T V m o b i l e _ r e d i r e c t _ i p a d " ,   " n o n " ,   e x p i r a t i o n _ c o o k i e ) ; 
         } 
 } 
 
 f u n c t i o n   E c r i r e C o o k i e ( n o m ,   v a l e u r ) 
 { 
 v a r   a r g v = E c r i r e C o o k i e . a r g u m e n t s ; 
 v a r   a r g c = E c r i r e C o o k i e . a r g u m e n t s . l e n g t h ; 
 v a r   e x p i r e s = ( a r g c   >   2 )   ?   a r g v [ 2 ]   :   n u l l ; 
 v a r   p a t h = ( a r g c   >   3 )   ?   a r g v [ 3 ]   :   n u l l ; 
 v a r   d o m a i n = ( a r g c   >   4 )   ?   a r g v [ 4 ]   :   n u l l ; 
 v a r   s e c u r e = ( a r g c   >   5 )   ?   a r g v [ 5 ]   :   f a l s e ; 
 d o c u m e n t . c o o k i e = n o m + " = " + e s c a p e ( v a l e u r ) + 
 ( ( e x p i r e s = = n u l l )   ?   " "   :   ( " ;   e x p i r e s = " + e x p i r e s . t o G M T S t r i n g ( ) ) ) + 
 ( ( p a t h = = n u l l )   ?   " "   :   ( " ;   p a t h = " + p a t h ) ) + 
 ( ( d o m a i n = = n u l l )   ?   " "   :   ( " ;   d o m a i n = " + d o m a i n ) ) + 
 ( ( s e c u r e = = t r u e )   ?   " ;   s e c u r e "   :   " " ) ; 
 } 
 
 f u n c t i o n   g e t C o o k i e V a l ( o f f s e t ) 
 { 
 v a r   e n d s t r = d o c u m e n t . c o o k i e . i n d e x O f   ( " ; " ,   o f f s e t ) ; 
 i f   ( e n d s t r = = - 1 )   e n d s t r = d o c u m e n t . c o o k i e . l e n g t h ; 
 r e t u r n   u n e s c a p e ( d o c u m e n t . c o o k i e . s u b s t r i n g ( o f f s e t ,   e n d s t r ) ) ; 
 } 
 f u n c t i o n   L i r e C o o k i e ( n o m ) 
 { 
 v a r   a r g = n o m + " = " ; 
 v a r   a l e n = a r g . l e n g t h ; 
 v a r   c l e n = d o c u m e n t . c o o k i e . l e n g t h ; 
 v a r   i = 0 ; 
 w h i l e   ( i < c l e n ) 
 { 
 v a r   j = i + a l e n ; 
 i f   ( d o c u m e n t . c o o k i e . s u b s t r i n g ( i ,   j ) = = a r g )   r e t u r n   g e t C o o k i e V a l ( j ) ; 
 i = d o c u m e n t . c o o k i e . i n d e x O f ( "   " , i ) + 1 ; 
 i f   ( i = = 0 )   b r e a k ; 
 
 } 
 r e t u r n   n u l l ; 
 } 
 * / 