final testContractScript = {
  'code': [
    {
      'prim': 'storage',
      'args': [
        {'prim': 'int'}
      ]
    },
    {
      'prim': 'parameter',
      'args': [
        {'prim': 'unit'}
      ]
    },
    {
      'prim': 'code',
      'args': [
        [
          {'prim': 'CDR'},
          {
            'prim': 'NIL',
            'args': [
              {'prim': 'operation'}
            ]
          },
          {'prim': 'PAIR'}
        ]
      ]
    }
  ],
  'storage': {'int': '12'}
};