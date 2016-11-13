--created & coded by Lyris
--ソウル・インバージョン・チャネル－青
function c101010439.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101010439.op)
	c:RegisterEffect(e1)
end
c101010439.global_check=false
function c101010439.filter(c)
	return c:GetOriginalType()==TYPE_MONSTER+TYPE_EFFECT
end
function c101010439.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c101010439.global_check then return end
	c101010439.global_check=true
	local g=Duel.GetFieldGroup(tp,0xff,0xff)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsSetCard(0xe9) then
			if c101010439.filter(tc) then
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_SPSUMMON_PROC)
				e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
				e1:SetRange(LOCATION_HAND)
				e1:SetCondition(c101010439.evcon)
				e1:SetOperation(c101010439.evop)
				e1:SetValue(8751)
				tc:RegisterEffect(e1)
				local e0=Effect.CreateEffect(tc)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_ADD_TYPE)
				e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e0:SetValue(TYPE_XYZ)
				tc:RegisterEffect(e0)
				local e5=Effect.CreateEffect(tc)
				e5:SetDescription(aux.Stringid(101010260,0))
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				tc:RegisterEffect(e5)
				local e7=Effect.CreateEffect(tc)
				e7:SetType(EFFECT_TYPE_SINGLE)
				e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e7:SetCode(EFFECT_IMMUNE_EFFECT)
				e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e7:SetCondition(c101010439.con)
				e7:SetValue(c101010439.efilter)
				tc:RegisterEffect(e7)
			end
		end
		tc=g:GetNext()
	end
end
function c101010439.addc(e)
	local c=e:GetHandler()
	c:CompleteProcedure()
	local lv=c:GetOriginalLevel()
	if lv==nil then lv=c:GetRank() end
	c:AddCounter(0x88,lv)
end
function c101010439.evfilter(c,lv,g)
	local tlv=c:GetLevel()
	return g:IsExists(c101010439.evolute,1,c,lv,tlv)
end
function c101010439.evolute(c,tlv,lv)
	return c:GetLevel()+lv==tlv
end
function c101010439.evcon(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	if lv==nil then lv=c:GetRank() end
	return g:IsExists(c101010439.evfilter,1,nil,lv,g)
end
function c101010439.evop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local m=g:FilterSelect(tp,c101010439.evfilter,1,1,nil,lv,g):GetFirst()
	mg:AddCard(m)
	local lv1=m:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local t=g:FilterSelect(tp,c101010439.evolute,1,1,m,lv,lv1)
	mg:Merge(t)
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+8751)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c101010439.addc)
	e2:SetReset(RESET_EVENT+EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_REMOVE_TYPE)
	e4:SetValue(TYPE_XYZ)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	--e5:set
	e5:SetOperation(c101010439.rmop)
	c:RegisterEffect(e5)
end
function c101010439.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler()==c then c:RemoveCounter(tp,0x88,1,REASON_EFFECT) end
end
function c101010439.con(e,tp,eg,ep,ev,re,r,rp)
   return e:GetHandler():GetCounter(0x88)>2
end
function c101010439.efilter(e,te)
	return te:IsHasCategory(CATEGORY_NEGATE+CATEGORY_DISABLE)
end
