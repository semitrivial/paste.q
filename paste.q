\d .paste

raw_input:"";
parsed_input:"";
inputpos:0;
countleft:0;
fquote:0b;
fslash:0b;
ferror:0b;

display_value:{[x]
  x:@[value;x;{[err]1 "'",err,"\n";ferror::1b}];
  if[ferror;ferror::0b;:(::)];
  if[x~(::);:(::)];
  1 .Q.s x;
 };

pi_wrapper:{[x]
  raw_input,:x;
  while[inputpos<count[raw_input];
    c:raw_input[inputpos];
    gotline:parse_one_char[c];
    if[gotline;
      raw_input::raw_input[inputpos+1+til[(count raw_input)-(inputpos+1)]];
      inputpos::0;
      to_interp:parsed_input;
      parsed_input::"";
      countleft::0;
      :display_value to_interp;
    ];
    inputpos::inputpos+1;
  ];
 };

parse_one_char:{[c]
  if[fquote;
    if[fslash;fslash::0b];
    if[c="\"";fquote::0b];
    parsed_input::parsed_input,$[c="\n";" ";c];
    :0b;
  ];
  if[c="\"";fquote::1b];
  if[c in "[({";countleft::countleft+1];
  if[c in "])}";countleft::countleft-1];
  if[c="\n";
    if[0>=countleft;:1b];
    parsed_input::parsed_input," ";
    :0b
  ];
  parsed_input::parsed_input,c;
  :0b
 };

\d .

.z.pi:.paste.pi_wrapper;
