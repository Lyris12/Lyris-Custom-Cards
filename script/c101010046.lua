--created & coded by Lyris
--EEキャルフレー
function c101010046.initial_effect(c)
c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c101010046.xcon)
	e0:SetTarget(c101010046.xtg)
	e0:SetOperation(aux.XyzOperation(aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH),0,2,2))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101010046.con)
	e2:SetTarget(c101010046.tg)
	e2:SetOperation(c101010046.op)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010046,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101010046.cost)
	e1:SetTarget(c101010046.target)
	e1:SetOperation(c101010046.activate)
	c:RegisterEffect(e1)
end
function c101010046.xfilter(c,tc,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeXyzMaterial(tc)
		and Duel.IsExistingMatchingCard(c101010046.xyzfilter,tp,LOCATION_MZONE,0,1,c,tc,c:GetLevel())
end
function c101010046.xyzfilter(c,tc,lv)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsCanBeXyzMaterial(tc)
		and c:GetLevel()~=lv
end
function c101010046.xcon(e,c,og)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-2 then return false end
	return Duel.IsExistingMatchingCard(c101010046.xfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c101010046.xtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c101010046.xfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c101010046.xyzfilter,tp,LOCATION_MZONE,0,1,1,g:GetFirst(),c,c:GetLevel())
	g:AddCard(g1:GetFirst())
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c101010046.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101010046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101010046.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101010046.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c101010046.filter(c,atk)
	return not c:IsType(TYPE_TOKEN)
		and ((c:IsLocation(LOCATION_HAND) and c:IsSetCard(0xeeb)) or (c:GetBaseAttack()<atk and c:IsAbleToChangeControler()))
end
function c101010046.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010046.filter,tp,LOCATION_HAND,LOCATION_MZONE,1,nil,e:GetHandler():GetAttack()) end
end
function c101010046.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c101010046.filter,tp,LOCATION_HAND,LOCATION_MZONE,1,1,nil,c:GetAttack())
	if g:GetCount()>=0 then
		local og=g:GetFirst():GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,g)
	end
end
