--強力海流
local id,ref=GIR()
function ref.start(c)
local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,id)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(ref.drop)
	c:RegisterEffect(e1)
end
ref.sea_scout_list=true
function ref.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5cd)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(ref.cfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(800)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function ref.filter(c,eg)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsAttribute(ATTRIBUTE_WATER) and tc:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function ref.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if eg:IsExists(ref.filter,1,nil,eg) then
		if Duel.Draw(tc:GetControler(),1,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tc:GetControler(),LOCATION_HAND,0)>4 then
			local ht=Duel.GetFieldGroupCount(tc:GetControler(),LOCATION_HAND,0)
			local g=Duel.SelectMatchingCard(tc:GetControler(),aux.TRUE,tc:GetControler(),LOCATION_HAND,0,ht-4,ht-4,nil)
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		end
	end
end
