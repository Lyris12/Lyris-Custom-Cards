--
local id,ref=GIR()
function ref.start(c)
--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(ref.ntcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(ref.ntop)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e0:SetValue(70095154)
	c:RegisterEffect(e0)
end
function ref.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end
function ref.ntop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.TargetBoolFunction(ref.nfilter))
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e3)
end
function ref.nfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsCode(id)
end
