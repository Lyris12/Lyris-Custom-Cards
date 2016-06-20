return function()
  Extensions.Register("math",1,0,"Math")
  function math.greater(a,b)
    return a>b
  end

  function math.less(a,b)
    return a<b
  end

  function math.greater_eq(a,b)
    return a>=b
  end

  function math.less_eq(a,b)
    return a<=b
  end

  function math.equal(a,b)
    return a==b
  end

  function math.not_equal(a,b)
    return a~=b
  end

  function math.add(a,b)
    return a+b
  end

  function math.subtract(a,b)
    return a-b
  end

  function math.multiply(a,b)
    return a*b
  end

  function math.divide(a,b)
    return a/b
  end
end
