    private: double kde( const Point& Xq, int nodeIdx = 0 ) {
                Node* node = nodesPtrs[ nodeIdx ];

                if ( node -> isLeaf() ) {
                        value_leaf = kernel( Xq, points[ node->pIdx ] );
                        return value_leaf;
                }

                value_current = kernel( Xq, points[ nodes->pIdx ] );
                value_left    = kde( Xq, nodes->LIdx );
                value_right   = kde( Xq, nodes->RIdx );

                total = value_current + value_left + value_right;

                return total;
             }

    private: double kernel( const vector<double>&a, const vector<double> &b  ) {
                kk = exp( -distance_squared(a, b) );
                return kk;
             }
