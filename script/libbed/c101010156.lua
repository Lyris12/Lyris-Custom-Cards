--ＳＳ－九世のナイク
local id,ref=GIR()
function ref.start(c)
--level
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UPDATE_LEVEL)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(ref.val)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(ref.spcon)
	c:RegisterEffect(e1)
end
function ref.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0
		and Duel.GetFieldGroupCount(e:GetHandler():GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(ref.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function ref.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x5cd)
end
function ref.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x5cd)
end
function ref.val(e)
	return Duel.GetMatchingGroupCount(ref.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())
end
